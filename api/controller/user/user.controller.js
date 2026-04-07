const { Op } = require('sequelize');
const { reqUser, reqUserRole, reqUserRoleMapping, sequelize, Sequelize } = require('../../../models');

exports.createUser = async (req, res, next) => {

    let { userMultipleRole, ...parameter } = req.body;
    let { userEmail, userType } = parameter;

    try {
        const userIspresent = await reqUser.findOne({
            where: {
                userEmail,
                userStatus: 'active'
            },
        });

        if (userIspresent) {
            return res.status(400).send({ status: false, userExit: true, message: 'user already exists with given email' });
        }

        let rolesArray = [];
        if (Array.isArray(parameter.userRole)) {
            rolesArray = [...parameter.userRole];
        } else if (parameter.userRole) {
            rolesArray.push(parameter.userRole);
        }

        if (Array.isArray(userMultipleRole)) {
            rolesArray = [...rolesArray, ...userMultipleRole];
        } else if (userMultipleRole) {
            rolesArray.push(userMultipleRole);
        }

        const uniqueRoles = [...new Set(rolesArray)].filter(Boolean);
        let dbRoles = [];
        if (uniqueRoles.length > 0) {
            dbRoles = await reqUserRole.findAll({
                where: { roleName: { [Op.in]: uniqueRoles } }
            });
            const roleIds = dbRoles.map(role => role.roleId);
            parameter.userRole = roleIds.join(',');
        }

        const user = await reqUser.create(parameter);

        if (dbRoles.length > 0) {
            const roleMappingsToInsert = dbRoles.map(role => ({
                userId: user.userId,
                roleId: role.roleId
            }));
            await reqUserRoleMapping.bulkCreate(roleMappingsToInsert);
        }

        const userData = await reqUser.findOne({
            attributes: {
                exclude: ['userPassword', 'createdAt', 'updatedAt']
            },
            where: {
                userId: user.userId,
            },
            include: [{
                model: reqUserRole, as: 'userRoles'
            }]
        });

        // 🔹 Get roles from mapping table
        let roles = await reqUserRoleMapping.findAll({
            where: { userId: user.userId },

            include: [{
                model: reqUserRole,
                as: 'role',
                required: true
            }]
        });

        // Convert roles → ["admin","visitor"]
        let formattedRoles = roles.map(r =>
            r.role ? r.role.roleName : null
        ).filter(role => role !== null);

        // Convert response
        let responseData = userData.toJSON();
        responseData.userRole = formattedRoles;

        return res.status(200).send(responseData);

    } catch (error) {
        next(error);
    }

}


const userRole = async (data) => new Promise(async (resolve, reject) => {
    try {
        const isPresent = await reqUserRole.findOne({
            where: {
                roleUserId: data.roleUserId,
                roleName: data.roleName,
            },
        });
        if (!isPresent) {
            await reqUserRole.create(data);
        }
        resolve(true);
    } catch (error) {
        reject(error);
    }
});


exports.deleteUser = async (req, res, next) => {
    try {
        const { userId } = req.body;
        const data = await reqUser.update(
            {
                userStatus: 'inactive'
            },
            {
                where: {
                    userId: userId,
                    userStatus: 'active'
                },
            },
        );
        if (data[0] == 1) return res.status(200).json({ status: true, message: 'user deleted successfully' });
        return res.status(400).json({ status: false, message: 'user not found' });

    } catch (error) {
        next(error);
        // return res.status(400).send({ status: false, message: error });
    }
};


exports.UpdateUser = async (req, res, next) => {
    let { userfirstName, userlastName, userEmail, userDOB, userWorkStation, userRole } = req.body;
    let { userId } = req.query;
    try {
        const userIspresent = await reqUser.findOne({
            where: {
                userId,
                userStatus: 'active'
            },
        });
        // console.log(userIspresent);
        if (!userIspresent) return res.status(400).send({ status: false, message: 'user Not found with this Id' });
        let userData = {};
        if (userlastName) userData.userlastName = userlastName;
        if (userfirstName) userData.userfirstName = userfirstName;
        if (userEmail) userData.userEmail = userEmail;
        if (userDOB) userData.userDOB = userDOB;
        if (userWorkStation) userData.userWorkStation = userWorkStation;
        
        let roleIds = [];
        if (userRole) {
            let rolesArray = Array.isArray(userRole) ? userRole : (typeof userRole === 'string' ? userRole.split(',') : [userRole]);
            let uniqueRoles = [...new Set(rolesArray)].filter(Boolean);

            const isNumeric = uniqueRoles.every(role => !isNaN(role));
            if (!isNumeric) {
                const dbRoles = await reqUserRole.findAll({
                    where: { roleName: { [Op.in]: uniqueRoles } }
                });
                roleIds = dbRoles.map(role => role.roleId);
            } else {
                roleIds = uniqueRoles;
            }
            userData.userRole = roleIds.join(',');
        }

        let [user, data] = await reqUser.update(userData, {
            where: { userId: userId },
            returning: true,
        });

        // Update reqUserRoleMapping
        if (userRole) {
            await reqUserRoleMapping.destroy({ where: { userId: userId } });

            if (roleIds.length > 0) {
                const roleMappingsToInsert = roleIds.map(roleId => ({
                    userId: userId,
                    roleId: roleId
                }));
                await reqUserRoleMapping.bulkCreate(roleMappingsToInsert);
            }
        }

        data[0].userPassword = null;

        if (!user) return res.status(400).send({ status: false, message: 'something went wrong' });
        return res.status(200).send({ status: true, message: 'user updated', data: data[0] });

    } catch (error) {
        next(error);
    }

}


exports.listUsers = async (req, res, next) => {
    try {
        let { limit, page, userRole, search,mailSearch } = req.query;
        // Convert limit and page to integers
        limit = limit ? parseInt(limit, 10) : 100;
        page = page ? parseInt(page, 10) : 1;
        let query = {
            limit,
            offset: (page - 1) * limit,
            order: [["userId", "DESC"]]
        };
        let where = {
            userStatus: 'active'
        };
        // Assign userWorkStation based on userRole
        const workStationMap = {
            1: 1, // TALENT TEAM
            2: { [Op.in]: [1,2,3,4,5] }, // MANAGERS
            3: { [Op.in]: [2, 3, 5] } // PANEL
        };
        if (userRole && workStationMap[userRole]) {
            where.userWorkStation = workStationMap[userRole];
        }
	    if(userRole==2){
		    where[Op.or]=[{userRole:'2'},{userRole:'1'}];
	    };
        // Apply search on both first name and last name
        if (search) {
            where[Op.or] = [
                { userfirstName: { [Op.iLike]: `${search}%` } },
                { userlastName: { [Op.iLike]: `${search}%` } },
            ];
        }
        if (mailSearch) {
            where[Op.or] = [
                { userEmail: { [Op.iLike]: `%${mailSearch}%` } },
            ];
        }
        // Fetch users
        let users = await reqUser.findAll({
            attributes: ['userId', 'userfirstName', 'userlastName', 'userEmail', 'userDOB', 'userWorkStation', 'userRole', 'userType', 'userStatus'],
            where,
            ...query
        });

        // 🔹 Get all roles to map IDs back to Role Names dynamically
        const dbRoles = await reqUserRole.findAll({
            attributes: ['roleId', 'roleName']
        });
        const roleMap = {};
        dbRoles.forEach(role => {
            roleMap[role.roleId] = role.roleName;
        });

        const formattedUsers = users.map(user => {
            let userData = user.toJSON();
            // Convert userRole comma-separated string into an array of resolving roleNames
            if (userData.userRole && typeof userData.userRole === 'string') {
                const mappedRoles = userData.userRole.split(',').map(roleId => roleMap[roleId] || roleId);
                userData.userRole = mappedRoles;
            }
            return userData;
        });

        // Count total users (efficient count query)
        const totalCount = await reqUser.count({ where });
        return res.status(200).json({
            status: true,
            message: 'Data retrieved',
            userCount: totalCount,
            users: formattedUsers
        });
    } catch (error) {
        next(error);
    }
};


exports.reqUsersList = async (req, res, next) => {
    try {
        const params = req.params.id;
        const reqUsersData = await reqUser.findOne({
            attributes: ['userfirstName', 'userlastName', 'userEmail', 'userDOB', 'userWorkStation', 'userRole', 'userType', 'userStatus',
                [
                    sequelize.literal(`(
                        SELECT "stationName" 
                        FROM "reqStations"
                        WHERE "stationId"="userWorkStation"
                    )`),
                    'station'
                ]
            ],
            raw: true,
            where: {
                userId: params
            }
        })
        return res.status(200).json({
            success: true,
            data: reqUsersData
        })
    } catch (error) {
        next(error);
    }
}

