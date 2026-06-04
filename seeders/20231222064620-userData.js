'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("reqUsers", [
      {
        "userfirstName": "Geethu", "userlastName": "Angel", "userEmail": "geethu@techversantinfotech.com", "userPassword": "geethu@techversantinfotech.com", "userWorkStation": 1, "userRole": "talent", "userType": "user", "userStatus": "active", "createdAt": new Date(),
        "updatedAt": new Date()
      },
      {
        "userfirstName": "Maloo", "userlastName": "Vijayan", "userEmail": "maloovijayan@techversantinfotech.com", "userPassword": "maloovijayan@techversantinfotech.com", "userWorkStation": 1, "userRole": "talent", "userType": "user", "userStatus": "active", "createdAt": new Date(),
        "updatedAt": new Date()
      },
      {
        "userfirstName": "Jiji", "userlastName": "George", "userEmail": "jijigeorge@techversantinfotech.com", "userPassword": "jijigeorge@techversantinfotech.com", "userWorkStation": 1, "userRole": "talent", "userType": "user", "userStatus": "active", "createdAt": new Date(),
        "updatedAt": new Date()
      },
      {
        "userfirstName": "Neenu", "userlastName": "Hormis", "userEmail": "neenu@techversantinfotech.com", "userPassword": "neenu@techversantinfotech.com", "userWorkStation": 1, "userRole": "talent", "userType": "user", "userStatus": "active", "createdAt": new Date(),
        "updatedAt": new Date()
      },
      {
        "userfirstName": "Parvathy", "userlastName": "M", "userEmail": "parvathy.m@techversantinfo.com", "userPassword": "parvathy.m@techversantinfo.com", "userWorkStation": 1, "userRole": "talent", "userType": "user", "userStatus": "active", "createdAt": new Date(),
        "updatedAt": new Date()
      },
      {
        "userfirstName": "Shreya", "userlastName": "Elza Shibu", "userEmail": "shreyaelzashibu@techversantinfotech.com", "userPassword": "shreyaelzashibu@techversantinfotech.com", "userWorkStation": 1, "userRole": "talent", "userType": "user", "userStatus": "active", "createdAt": new Date(),
        "updatedAt": new Date()
      },
      {
        "userfirstName": "Admin", "userlastName": "Admin", "userEmail": "admin@techversantinfotech.com", "userPassword": "admin@techversantinfotech.com", "userWorkStation": 1, "userRole": "talent", "userType": "admin", "userStatus": "active", "createdAt": new Date(),
        "updatedAt": new Date()
      }
    ]
    )
  },

  async down(queryInterface, Sequelize) {

  }
};
