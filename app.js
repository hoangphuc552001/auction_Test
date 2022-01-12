import express from 'express';
import morgan from 'morgan';
import activate_view_middleware from './middlewares/view.mdw.js';
import activate_route_middleware from './middlewares/routes.mdw.js'
import activate_locals_middleware from './middlewares/localsmiddleware.js';
import activate_session_middleware from './middlewares/sessions.mdw.js';
import mail_middleware from './middlewares/mail.mdw.js'
import asyncErrors from 'express-async-errors'
import cron from 'node-cron';
import crypt from "./utils/crypt.js";
import mailgu from "mailgun-js";
import productmodel from "./models/productmodel.js";
//expressjs declare
const app = express()
const port = 3000
app.use('/public',express.static('public'))
//morgan
app.use(morgan('dev'));
//middleware declare for post method
app.use(express.urlencoded({extended:true}));
//view


app.use('/public',express.static('public'))
activate_session_middleware(app);
activate_locals_middleware(app)

activate_view_middleware(app);
//routes
activate_route_middleware(app);
//
mail_middleware(app);
app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
})