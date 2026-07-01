const re = /CREATE\s+(?:(?:ALGORITHM=UNDEFINED\s+)?DEFINER=`[^`]+@[^`]+`\s+)?(PROCEDURE|FUNCTION|TRIGGER|EVENT)\s+(?:IF NOT EXISTS\s+)?`([^`]+)`/i;
const sub = 'DEFINER=`root`@`localhost`';
const re2 = new RegExp('DEFINER=`[^`]+@[^`]+`');
console.log('sub:', sub.match(re2));
const line = 'CREATE DEFINER=`root`@`localhost` PROCEDURE `seed`()';
console.log('full exec:', line.match(re));
console.log('full test:', re.test(line));

const re3 = /CREATE\s+DEFINER=`[^`]+@[^`]+`\s+PROCEDURE\s+`([^`]+)`/i;
console.log('simple:', line.match(re3));
