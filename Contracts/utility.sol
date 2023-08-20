// SPDX-License-Identifier: MIT
// SSI Layer 1 Utility Contract

pragma solidity ^0.8.18;

contract Utility {

    address owner;

    struct NYM {
        uint8 role;
        uint8 version;
        string endpoint;
    }
    mapping(address => NYM) public NYMs;

    struct SCHEMA {
        address schema_owner;
        address trust_registry;
        uint8 version;
        bytes20 schema_id;
        string name;
        string[] attributes;
    }
    mapping(bytes20 => SCHEMA) public SCHEMAs;

    struct CRED_DEF {
        address cred_def_owner;
        address trust_registry;
        address revocation_registry;
        uint8 signature;
        bytes20 cred_def_id;
        bytes20 schema_id;
        string tag;
    }
    mapping(bytes20 => CRED_DEF) public CRED_DEFs;

    // Deploy the contract and create the deployer as an endorser
    constructor() {
        owner = msg.sender;
        // Create new NYM record
        NYM memory owner_nym = NYM(2, 1, "");
        // Map DID to NYM record
        NYMs[msg.sender] = owner_nym;
    }

    function registerNYM(address _dest, uint8 _role, uint8 _version, string memory _endpoint) public {

        // Check if NYM exists already
        require(NYMs[_dest].role==0);
        // Only endorser signed calls can register (role 2==ENDORSER)
        require(NYMs[msg.sender].role==2);
        // Create new NYM record
        NYM memory new_nym = NYM(_role, _version, _endpoint);
        // Map DID to NYM record
        NYMs[_dest] = new_nym;
    }

    function getNYM(address _dest) public view returns(NYM memory) {

        return NYMs[_dest];
    }

    function registerSchema(
        address _schema_owner,
        address _trust_registry,
        uint8 _version,
        string calldata _name,
        string[] calldata  _attributes) public returns(bytes20) {

        // Only endorser signed calls can register (role 2==ENDORSER)
        require(NYMs[msg.sender].role==2);
        // Create schema ID
        bytes20 _schema_id = ripemd160(bytes(abi.encode(_name)));
        // Make sure this schema_id has not been used before
        while (SCHEMAs[_schema_id].version != 0) {
            _schema_id = ripemd160(abi.encodePacked(_schema_id));
        }

        // Create new record
        SCHEMA memory new_schema = SCHEMA(_schema_owner, _trust_registry, _version, _schema_id, _name, _attributes);
        // Map schema ID to SCHEMA record
        SCHEMAs[_schema_id] = new_schema;

        return _schema_id;
    }

    function getSCHEMA(bytes20 _schema_id) public view returns(SCHEMA memory) {

        return SCHEMAs[_schema_id];
    }

    function registerCredDef(
        address _cred_def_owner,
        address _trust_registry,
        address _revocation_registry,
        uint8 _signature,
        bytes20 _schema_id,
        string calldata _tag) public returns(bytes20){

        // Only endorser signed calls can register (role 2==ENDORSER)
        require(NYMs[msg.sender].role==2);
        // Make sure schema exists
        require(SCHEMAs[_schema_id].version!=0);
        // Create cred_def ID
        bytes20 _cred_def_id = ripemd160(bytes(abi.encode(_tag)));
        // Make sure this cred_def_id has not been used before
        while (CRED_DEFs[_cred_def_id].signature != 0) {
            _cred_def_id = ripemd160(abi.encodePacked(_cred_def_id));
        }

        // Create new record
        CRED_DEF memory new_cred_def = CRED_DEF(_cred_def_owner, _trust_registry, _revocation_registry, _signature, _cred_def_id, _schema_id, _tag);
        // Map schema ID to SCHEMA record
        CRED_DEFs[_cred_def_id] = new_cred_def;
        return _cred_def_id;
    }

    function getCredDef(bytes20 _cred_def_id) public view returns(CRED_DEF memory) {

        return CRED_DEFs[_cred_def_id];
    }

}