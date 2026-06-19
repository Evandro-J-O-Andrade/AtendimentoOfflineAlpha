module.exports = {
    SECRET: process.env.JWT_SECRET || "super_secret_key",
    EXPIRES_IN: "8h"
};