'use strict';
const {
  Model
} = require('sequelize');

// module.exports = (sequelize, DataTypes) => {
//   class Project extends Model {
//     static associate(models) {
//       // define association here
//     }
//   }
//   Project.init({
//     title: DataTypes.STRING,
//     imageUrl: DataTypes.STRING,
//     description: DataTypes.TEXT,
//     userId: DataTypes.INTEGER
//   }, {
//     sequelize,
//     modelName: 'Project',
//   });
//   return Project;
// };

module.exports = (sequelize, DataTypes) => {
  const User = sequelize.define('User', {
    firstName: DataTypes.STRING,
    lastName:  DataTypes.STRING,
    email:     DataTypes.STRING,
    password:  DataTypes.STRING
  }, {});
  User.associate = function (models) {
    // associations can be defined here
    User.hasMany(models.Project, {
      foreignKey: 'userId'
    })
  };
  return User;
};
