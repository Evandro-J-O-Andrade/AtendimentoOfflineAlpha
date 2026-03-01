const AuthService = require("./authService");

class AuthController {

    static async login(req, res) {
        try {

            const { username, password } = req.body;

            const result = await AuthService.login(username, password);

            return res.json(result);

        } catch (err) {

            return res.status(401).json({
                error: "AUTH_FAILED",
                message: err.message
            });

        }
    }

}

module.exports = AuthController;