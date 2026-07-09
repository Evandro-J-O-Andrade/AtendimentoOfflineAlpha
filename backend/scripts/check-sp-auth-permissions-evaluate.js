const mysql = require('mysql2/promise');

(async () => {
  try {
    const conn = await mysql.createConnection({
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: '',
      database: 'pronto_atendimento'
    });

    const [rows] = await conn.query(
      "SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE='PROCEDURE' AND ROUTINE_NAME='sp_auth_permissions_evaluate' AND ROUTINE_SCHEMA=DATABASE()"
    );

    console.log(rows);
    await conn.end();
  } catch (e) {
    console.error(e);
    process.exit(1);
  }
})();
