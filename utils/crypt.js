import crypto from "crypto";

export default {
    encrypt(text) {
        let cipher = crypto.createCipher('aes-256-cbc', 'd6F3Efeq')
        let crypted = cipher.update(text, 'utf8', 'hex')
        crypted += cipher.final('hex');
        return crypted;
    },
    decrypt(text ){
        let decipher = crypto.createDecipher('aes-256-cbc', 'd6F3Efeq')
        let dec = decipher.update(text, 'hex', 'utf8')
        dec += decipher.final('utf8');
        return dec;
    }
}