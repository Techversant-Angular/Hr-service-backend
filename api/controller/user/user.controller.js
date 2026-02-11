const { Op } = require('sequelize');
const { reqUser, reqUserRole, sequelize, Sequelize } = require('../../../models');

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

        const user = await reqUser.create(parameter);

        //code commented because causing 400 error even after user is created 

        // userMultipleRole = [parameter.userRole, ...userMultipleRole];

        // let promise = await userMultipleRole.map(async (eachRole) => {
        //     await userRole({ roleName: eachRole, roleUserId: user.userId, userType });
        // });

        /* await Promise.all(promise); */

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
        return res.status(200).send(userData);

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
        if (userRole) userData.userRole = userRole;
        let [user, data] = await reqUser.update(userData, {
            where: { userId: userId },
            returning: true,
        });

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
		    where[Op.or]=[{userRole:'manager'},{userRole:'admin'}];
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
        // Count total users (efficient count query)
        const totalCount = await reqUser.count({ where });
        return res.status(200).json({
            status: true,
            message: 'Data retrieved',
            userCount: totalCount,
            users
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

