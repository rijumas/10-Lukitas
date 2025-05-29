const IngredientModel = require('../model/ingredient.model');

class IngredientService {
  static async addIngredient(userId, name, quantity) {
    const newIngredient = new IngredientModel({ userId, name, quantity });
    return await newIngredient.save();
  }

  static async getIngredientsByUser(userId) {
    return await IngredientModel.find({ userId });
  }
}

module.exports = IngredientService;
