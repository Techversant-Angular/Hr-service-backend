'use strict';
const bcrypt = require('bcryptjs');

const {
  Model
} = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class reqUser extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      reqUser.hasMany(models.reqUserRole, { foreignKey: 'roleUserId', as: 'userRoles' });
      reqUser.hasOne(models.reqReport, { foreignKey: 'recruiter', as: 'reportData' });
      reqUser.hasOne(models.reqreqruiterStationReport, { foreignKey: 'user', as: 'recruiter' });
    }
  }
  reqUser.init({
    userId: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    userfirstName: {
      type: DataTypes.TEXT,
      allowNull: false,
      validate: {
        notEmpty: {
          msg: 'Last name required',
        },
        notNull: {
          msg: 'First name required',
        },
      },
    },
    userlastName: {
      type: DataTypes.TEXT,
      allowNull: false,
      validate: {
        notNull: {
          msg: 'Last name required',
        },
        notEmpty: {
          msg: 'Last name required',
        }
      },
    },
    userEmail: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        notNull: {
          msg: 'Email required',
        },
        isEmail: {
          msg: 'Valid email id required',
        }
      }
    },
    userDOB: {
      type: DataTypes.DATE,
      // allowNull: false,
      validate: {
        // notNull: {
        //   msg: 'DoB required',
        // },
        isDate: {
          msg: 'Valid Date Format required'
        }
      }
    },
    userPassword: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        notNull: {
          msg: 'Password required',
        },
      },
    },
    userWorkStation: {
      type: DataTypes.INTEGER,
      allowNull: false,
      validate: {
        notNull: {
          msg: 'Specify the working station',
        },
      },
    },
    userRole: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        notNull: {
          msg: 'Specify the user Role',
        },
      },
    },
    userType: {
      type: DataTypes.STRING,
      defaultValue: "user"
    },
    userOtp: {
      type: DataTypes.STRING
    },
    useOtpExpire: {
      type: DataTypes.DATE
    },
    userStatus: {
      type: DataTypes.STRING,
      defaultValue: 'active'
    },
    userFullName: {
      type: DataTypes.VIRTUAL,
      get() {
        return `${this.userfirstName} ${this.userlastName}`;
      }
    }
  }, {
    sequelize,
    modelName: 'reqUser',
    hooks: {
      beforeCreate: (user) => {
        const salt = bcrypt.genSaltSync();
        user.userPassword = bcrypt.hashSync(user.userPassword, salt);
      },

    },
  });

  reqUser.prototype.validatePassword = async function (password) {
    const valid = await bcrypt.compare(password, this.userPassword);
    if (valid) {
      return valid;
    } else {
      return false;
    }
  };
  return reqUser;
};