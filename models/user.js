'use strict';
const {
  Model
} = require('sequelize');

// module.exports = (sequelize, DataTypes) => {
//   class User extends Model {
//     static associate(models) {
//       // define association here
//     }
//   }
//   User.init({
//     firstName: DataTypes.STRING,
//     lastName: DataTypes.STRING,
//     email: DataTypes.STRING,
//     password: DataTypes.STRING
//   }, {
//     sequelize,
//     modelName: 'User',
//   });
//   return User;
// };

module.exports = (sequelize, DataTypes) => {
  const Project = sequelize.define('Project', {
    title:       DataTypes.STRING,
    imageUrl:    DataTypes.STRING,
    description: DataTypes.TEXT,
    userId:      DataTypes.INTEGER
  }, {});
  Project.associate = function (models) {
    // associations can be defined here
    Project.belongsTo(models.User, {
      foreignKey: 'userId',
      onDelete: 'CASCADE'
    })
  };
  return Project;
};
