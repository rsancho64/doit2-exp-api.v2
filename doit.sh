# bash script
# recipe: https://levelup.gitconnected.com/build-an-express-api-with-sequelize-cli-and-express-router-963b6e274561

rm -Rf .git* package* 
# rm node_modules
git init
npm init -y
npm install --save mysql2 sequelize pg
npm install -D sequelize-cli
npm install -D nodemon 
npm install --save body-parser # to handle info from user requests
npm install --save express 

echo "
/node_modules
.DS_Store
.env" >> .gitignore

rm -Rf config/ migrations/ models/ seeders/

npx sequelize-cli init

cat << CONFIG..CONFIG.JSON > config/config.json
{
  "development": {
    "username": "root",
		"password": "bea",
		"database": "pp_api_dev",
		"host": "127.0.0.1",
		"dialect": "mysql"
  },

  "test": {
    "database": "pp_api_test",
    "dialect":  "mysql"
  },

  "production": {
    "use_env_variable": "DATABASE_URL",
    "dialect": "mysql",
    "dialectOptions": {
      "ssl": {
        "rejectUnauthorized": false
      }
    }
  }
}
CONFIG..CONFIG.JSON

# DB ----------------

mysql -u root -pbea -e "drop database if exists pp_api_dev;"
npx sequelize-cli db:create

# models n seed data ---------------- 

## User model:
npx sequelize-cli model:generate --name User \
--attributes firstName:string,lastName:string,email:string,password:string
npx sequelize-cli db:migrate

# npx sequelize-cli seed:generate --name users
cat << SEEDERS..0.USERS.JS > seeders/0-users.js
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.bulkInsert('Users', [{
      firstName: 'John',
      lastName:  'Doe',
      email:     'john@doe.com',
      password:  '123456789',
      createdAt: new Date(),
      updatedAt: new Date()
    },
    {
      firstName: 'John',
      lastName:  'Smith',
      email:     'john@smith.com',
      password:  '123456789',
      createdAt: new Date(),
      updatedAt: new Date()
    },
    {
      firstName: 'John',
      lastName:  'Stone',
      email:     'john@stone.com',
      password:  '123456789',
      createdAt: new Date(),
      updatedAt: new Date()
    }], {});
  },  down: (queryInterface, Sequelize) => {
    return queryInterface.bulkDelete('Users', null, {});
  }
};
SEEDERS..0.USERS.JS

## Project model:
npx sequelize-cli model:generate --name Project \
--attributes title:string,imageUrl:string,description:text,userId:integer
npx sequelize-cli db:migrate

## set associations between the two models ( user n projects )

cat << MODELS..USER.JS > models/user.js
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
MODELS..USER.JS

cat << MODELS..PROJECT.JS > models/project.js
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
MODELS..PROJECT.JS

# npx sequelize-cli seed:generate --name projects
cat << MIGRATIONS..0-CREATE-PROJECT.JS > migrations/0-create-project.js
'use strict';
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable('Projects', {
      id: {
        allowNull:     false,
        autoIncrement: true,
        primaryKey:    true,
        type: Sequelize.INTEGER
      },
      title: {
        type: Sequelize.STRING
      },
      imageUrl: {
        type: Sequelize.STRING
      },
      description: {
        type: Sequelize.TEXT
      },
      userId: {
        type: Sequelize.INTEGER,
        onDelete: 'CASCADE',
        references: {
          model: 'Users',
          key:   'id',
          as:    'userId',
        }
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  down: (queryInterface, Sequelize) => {
    return queryInterface.dropTable('Projects');
  }
};
MIGRATIONS..0-CREATE-PROJECT.JS

npx sequelize-cli db:migrate

# npx sequelize-cli seed:generate --name projects
cat << SEEDERS..0.PROJECTS.JS > seeders/0-projects.js
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.bulkInsert('Projects', [{
      title: 'Project 1',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png',
      description: 'Built using Vanilla JavaScript, HTML, and CSS',
      userId: 1,
      createdAt: new Date(),
      updatedAt: new Date()
    },
    {
      title: 'Project 2',
      imageUrl: 'https://www.stickpng.com/assets/images/584830f5cef1014c0b5e4aa1.png',
      description: 'Built using React & a 3rd-party API.',
      userId: 3,
      createdAt: new Date(),
      updatedAt: new Date()
    },
    {
      title: 'Project 3',
      imageUrl: 'https://expressjs.com/images/express-facebook-share.png',
      description: 'Built using Express & React.',
      userId: 2,
      createdAt: new Date(),
      updatedAt: new Date()
    },
    {
      title: 'Project 4',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/16/Ruby_on_Rails-logo.png',
      description: 'Built using Rails & React.',
      userId: 1,
      createdAt: new Date(),
      updatedAt: new Date()
    }], {});
  },  down: (queryInterface, Sequelize) => {
    return queryInterface.bulkDelete('Projects', null, {});
  }
};
SEEDERS..0.PROJECTS.JS

npx sequelize-cli db:seed:all

# test seeding:
mysql -u root -pbea -e "\
    use pp_api_dev;

    SELECT * FROM 
    Users JOIN Projects 
    ON Users.id = Projects.userId;
"

# use Express; set up routes ------------------------------------------

mkdir routes controllers
touch server.js  routes/index.js controllers/index.js

# update package.json
cat << PJS > package.json
{
  "name": "exp-api",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "start": "nodemon server.js",
    "db:reset": "npx sequelize-cli db:drop && npx sequelize-cli db:create && npx sequelize-cli db:migrate && npx sequelize-cli db:seed:all"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "body-parser": "^1.19.1",
    "express": "^4.17.2",
    "mysql2": "^2.3.3",
    "pg": "^8.7.3",
    "sequelize": "^6.16.1"
  },
  "devDependencies": {
    "nodemon": "^2.0.15",
    "sequelize-cli": "^6.4.1"
  }
}
PJS

cat << ROUTES..INDEX.JS > routes/index.js
const { Router } = require('express');
const controllers = require('../controllers');
const router = Router();router.get('/', (req, res) => res.send('HOME! '))

router.post('/users', controllers.createUser)
router.get( '/users', controllers.getAllUsers)
router.get('/users/:id', controllers.getUserById)

module.exports = router
ROUTES..INDEX.JS

cat << SERVER.JS > server.js
const express = require('express');
const routes = require('./routes');
const bodyParser = require('body-parser')
const PORT = process.env.PORT || 3000;
const app = express();
app.use(bodyParser.json());
app.use('/api', routes);
app.listen(PORT, () => console.log('escucha en puerto' , PORT))
SERVER.JS

cat << CONTROLLERS..INDEX.JS > controllers/index.js
const { User, Project } = require('../models');

const createUser = async (req, res) => {
    try {
        const user = await User.create(req.body);
        return res.status(201).json({
            user,
        });
    } catch (error) {
        return res.status(500).json({ error: error.message })
    }
}

const getAllUsers = async (req, res) => {
    try {
        const users = await User.findAll({
            include: [
                {
                    model: Project
                }
            ]
        });
        return res.status(200).json({ users });
    } catch (error) {
        return res.status(500).send(error.message);
    }
}

const getUserById = async (req, res) => {
    try {
        const { id } = req.params;
        const user = await User.findOne({
            where: { id: id },
            include: [
                {
                    model: Project
                }
            ]
        });
        if (user) {
            return res.status(200).json({ user });
        }
        return res.status(404).send('User with the specified ID does not exists');
    } catch (error) {
        return res.status(500).send(error.message);
    }
}
module.exports = {
    createUser,
    getAllUsers,
    getUserById
}
CONTROLLERS..INDEX.JS