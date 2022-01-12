
import session from "express-session";
import MySQLStore  from 'express-mysql-session'
export default function(app) {
  app.set('trust proxy', 1)
  app.use(session({
    secret: 'keyboard cat',
    resave: true,
    saveUninitialized: true,
    cookie: { secure: false, maxAge: 10800000},
    store: new MySQLStore({
      connectionLimit: 100,
      host : 'us-cdbr-east-05.cleardb.net',
      user : 'be44caddfce4b6',
      password : '00bbb032',
      database : 'heroku_7067838459c52ba',
      charset: 'utf8mb4_general_ci',
      schema: {
        tableName: 'sessions',
        columnNames: {
          session_id: 'session_id',
          expires: 'expires',
          data: 'data'
        }
      }
    }),
  }))
};
