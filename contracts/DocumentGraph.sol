// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DocumentGraph {

    enum ValueType { STRING, INTEGER, BOOLEAN }

    struct Value {
        ValueType valueType;
        string stringValue;
        int intValue;
        bool boolValue;
    }

    struct Document {
        uint256 id;
        string docType;
        mapping(string => Value) properties;
        mapping(string => mapping(uint256 => bool)) edges; // For efficient edge existence checks
        mapping(string => uint256[]) edgeList; // To keep the list of edges for each name
    }

    mapping(uint256 => Document) public documents;
    uint256 public documentCount;

    event DocumentCreated(uint256 indexed id, string docType);
    event EdgeAdded(uint256 indexed fromId, string indexed name, uint256 indexed toId);
    event PropertySet(uint256 indexed id, string key, Value value);

    function createDocument(string memory _docType) public returns (uint256) {
        documentCount++;
        Document storage newDocument = documents[documentCount];
        newDocument.id = documentCount;
        newDocument.docType = _docType;
        emit DocumentCreated(documentCount, _docType);
        return documentCount;
    }

    function addEdge(uint256 _fromId, string memory _name, uint256 _toId) public {
        require(_fromId > 0 && _fromId <= documentCount, "Invalid fromId");
        require(_toId > 0 && _toId <= documentCount, "Invalid toId");

        documents[_fromId].edges[_name][_toId] = true;
        documents[_fromId].edgeList[_name].push(_toId);
        emit EdgeAdded(_fromId, _name, _toId);
    }

    function setStringProperty(uint256 _id, string memory _key, string memory _value) public {
        require(_id > 0 && _id <= documentCount, "Invalid document ID");

        Document storage doc = documents[_id];
        doc.properties[_key] = Value(ValueType.STRING, _value, 0, false);
        emit PropertySet(_id, _key, doc.properties[_key]);
    }

    function setIntProperty(uint256 _id, string memory _key, int _value) public {
        require(_id > 0 && _id <= documentCount, "Invalid document ID");

        Document storage doc = documents[_id];
        doc.properties[_key] = Value(ValueType.INTEGER, "", _value, false);
        emit PropertySet(_id, _key, doc.properties[_key]);
    }

    function setBoolProperty(uint256 _id, string memory _key, bool _value) public {
        require(_id > 0 && _id <= documentCount, "Invalid document ID");

        Document storage doc = documents[_id];
        doc.properties[_key] = Value(ValueType.BOOLEAN, "", 0, _value);
        emit PropertySet(_id, _key, doc.properties[_key]);
    }

    function getStringProperty(uint256 _id, string memory _key) public view returns (string memory) {
        require(_id > 0 && _id <= documentCount, "Invalid document ID");
        require(documents[_id].properties[_key].valueType == ValueType.STRING, "Not a string property");

        return documents[_id].properties[_key].stringValue;
    }

    function getIntProperty(uint256 _id, string memory _key) public view returns (int) {
        require(_id > 0 && _id <= documentCount, "Invalid document ID");
        require(documents[_id].properties[_key].valueType == ValueType.INTEGER, "Not an integer property");

        return documents[_id].properties[_key].intValue;
    }

    function getBoolProperty(uint256 _id, string memory _key) public view returns (bool) {
        require(_id > 0 && _id <= documentCount, "Invalid document ID");
        require(documents[_id].properties[_key].valueType == ValueType.BOOLEAN, "Not a boolean property");

        return documents[_id].properties[_key].boolValue;
    }

    function getEdges(uint256 _id, string memory _name) public view returns (uint256[] memory) {
        require(_id > 0 && _id <= documentCount, "Invalid document ID");
        return documents[_id].edgeList[_name];
    }

    function getDocument(uint256 _id) public view returns (uint256, string memory) {
        require(_id > 0 && _id <= documentCount, "Invalid document ID");
        Document storage doc = documents[_id];
        return (doc.id, doc.docType);
    }

    function hasEdge(uint256 _fromId, string memory _name, uint256 _toId) public view returns (bool) {
        require(_fromId > 0 && _fromId <= documentCount, "Invalid fromId");
        require(_toId > 0 && _toId <= documentCount, "Invalid toId");

        return documents[_fromId].edges[_name][_toId];
    }
}
