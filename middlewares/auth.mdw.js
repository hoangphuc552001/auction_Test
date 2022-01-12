export default function validate(req,res,next){
    if(req.session.authenticated===false){
        req.session.retUrl = req.originalUrl;
        return res.redirect('./login');
    }
    next();
}