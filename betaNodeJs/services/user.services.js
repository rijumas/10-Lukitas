const UserModel = require('../model/user.model');
const jwt = require("jsonwebtoken");

class UserService{
    static async registerUser(name, email, password){
        try{
            const createUser = new UserModel({name, email, password});
            return await createUser.save();
        }catch(err){
            throw err;
        }
    }
    static async getUserByEmail(email){
        try{
            return await UserModel.findOne({email});
        }catch(err){
            console.log(err);
        }
    }
    static async checkUser(email){
        try {
            return await UserModel.findOne({email});
        } catch (error) {
            throw error;
        }
    }
    static async generateAccessToken(tokenData,JWTSecret_Key,JWT_EXPIRE){
        return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
    }
}

module.exports = UserService;