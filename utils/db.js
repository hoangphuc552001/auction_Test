import fn from "knex";
const knex = fn({
    client: 'mysql2',
    connection: {
        host : 'us-cdbr-east-05.cleardb.net',
        user : 'be44caddfce4b6',
        password : '00bbb032',
        database : 'heroku_7067838459c52ba'
    },
    pool: { min: 0, max: 10 },
});
export default knex;