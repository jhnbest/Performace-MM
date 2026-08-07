const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

let weakPasswords = new Set();
let weakPasswordMD5 = new Set();

function md5Hash(str) {
  return crypto.createHash('md5').update(str).digest('hex');
}

function loadWeakPasswords() {
  try {
    const txtFilePath = path.join(__dirname, '../weakPasswords.txt');

    if (fs.existsSync(txtFilePath)) {
      const data = fs.readFileSync(txtFilePath, 'utf8');
      const lines = data.split(/\r?\n/);
      for (let line of lines) {
        line = line.trim();
        if (line && line.length > 0) {
          weakPasswords.add(line);
          weakPasswordMD5.add(md5Hash(line));
        }
      }
      console.log(`Loaded ${weakPasswords.size} weak passwords from weakPasswords.txt`);
    } else {
      console.log('weakPasswords.txt not found');
    }
  } catch (err) {
    console.error('Error loading weak passwords:', err);
  }
}

function isWeakPassword(password) {
  if (weakPasswords.size === 0) {
    loadWeakPasswords();
  }
  if (weakPasswords.has(password)) {
    return true;
  }
  if (weakPasswordMD5.has(password)) {
    return true;
  }
  return false;
}

function addWeakPassword(password) {
  weakPasswords.add(password);
  weakPasswordMD5.add(md5Hash(password));
}

function getWeakPasswords() {
  if (weakPasswords.size === 0) {
    loadWeakPasswords();
  }
  return Array.from(weakPasswords);
}

loadWeakPasswords();

module.exports = {
  isWeakPassword,
  addWeakPassword,
  getWeakPasswords,
  loadWeakPasswords
};
