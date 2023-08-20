"use strict";
var _a;
Object.defineProperty(exports, "__esModule", { value: true });
var solc_1 = require("solc");
var path_1 = require("path");
var fs_1 = require("fs");
var url_1 = require("url");
var __filename = (0, url_1.fileURLToPath)(import.meta.url);
var __dirname = path_1.default.dirname(__filename);
var fileName = 'utility.sol';
var contractName = 'Utility';
var contractPath = path_1.default.join(__dirname, '../..', 'contracts', fileName);
var sourceCode = fs_1.default.readFileSync(contractPath, 'utf8');
var input = {
    language: 'Solidity',
    sources: (_a = {},
        _a[fileName] = {
            content: sourceCode,
        },
        _a),
    settings: {
        outputSelection: {
            '*': {
                '*': ['*'],
            },
        },
        evmVersion: 'london',
    },
};
var compiledCode = JSON.parse(solc_1.default.compile(JSON.stringify(input)));
var bytecode = compiledCode.contracts[fileName][contractName].evm.bytecode.object;
var bytecodePath = path_1.default.join(__dirname, '..', 'UtilityBytecode.bin');
fs_1.default.writeFileSync(bytecodePath, bytecode);
console.log('Contract Bytecode:\n', bytecode);
var abi = compiledCode.contracts[fileName][contractName].abi;
var abiPath = path_1.default.join(__dirname, '..', 'UtilityAbi.json');
fs_1.default.writeFileSync(abiPath, JSON.stringify(abi, null, '\t'));
console.log('Contract ABI:\n', abi);
