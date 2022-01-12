import knex from "./db";

let mysql = require('mysql');
let config = {
    host : '127.0.0.1',
    port : 3306,
    user : 'root',
    password : '',
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