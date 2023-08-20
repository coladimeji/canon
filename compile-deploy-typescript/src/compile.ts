import solc from 'solc';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const fileName = 'utility.sol';
const contractName = 'Utility';

const contractPath = path.join('/home/coladimeji/besu/canon/Contracts', fileName);
const sourceCode = fs.readFileSync(contractPath, 'utf8');

const input = {
    language: 'Solidity',
    sources: {
        [fileName]: {
            content: sourceCode,
        },
    },
    settings: {
        outputSelection: {
            '*': {
                '*': ['*'],
            },
        },
        evmVersion: 'london',
    },
};

const compiledCode = JSON.parse(solc.compile(JSON.stringify(input)));

const bytecode = compiledCode.contracts[fileName][contractName].evm.bytecode.object;

const bytecodePath = path.join(__dirname, '..', 'UtilityBytecode.bin');
fs.writeFileSync(bytecodePath, bytecode);

console.log('Contract Bytecode:\n', bytecode);

const abi = compiledCode.contracts[fileName][contractName].abi;

const abiPath = path.join(__dirname, '..', 'UtilityAbi.json');
fs.writeFileSync(abiPath, JSON.stringify(abi, null, '\t'));

console.log('Contract ABI:\n', abi);
