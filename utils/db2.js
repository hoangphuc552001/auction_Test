import knex from "./db";

let mysql = require('mysql');
let config = {
    host : 'us-cdbr-east-05.cleardb.net',
    user : 'be44caddfce4b6',
    password : '00bbb032',
    database : 'heroku_7067838459c52ba'
};
let connection = mysql.createConnection(config);

let sql = `CALL filterTodo(?)`;

connection.query(sql, true, (error, results, fields) => {
    if (error) {
        return console.error(error.message);
    }
    console.log(results[0]);
});

connection.end();
export default ;