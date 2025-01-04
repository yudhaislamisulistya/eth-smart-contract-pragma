// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

contract CourseManagement {
    enum Status {
        Inactive,
        Active
    }
    
    struct Course {
        string name;
        uint quota;
        Status status;
        bool exists;
    }

    mapping(bytes32 => Course) public courses;
    bytes32[] public courseCodes;

    function generateCode(string memory _name, uint _quota) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_name, _quota));
    }

    function addCourse(string memory _name, uint _quota, Status _status) public {
        bytes32 code = generateCode(_name, _quota);

        require(!courses[code].exists, "Course already exists");

        courses[code] = Course({
            name: _name,
            quota: _quota,
            status: _status,
            exists: true
        });

        courseCodes.push(code);
    }

    function getAllCourses()
        public
        view
        returns (
            bytes32[] memory,
            string[] memory,
            Status[] memory,
            uint[] memory
        )
    {
        uint count = courseCodes.length;

        string[] memory names = new string[](count);
        Status[] memory statuses = new Status[](count);
        uint[] memory quotas = new uint[](count);

        for (uint i = 0; i < count; i++) {
            bytes32 code = courseCodes[i];
            Course memory course = courses[code];
            names[i] = course.name;
            statuses[i] = course.status;
            quotas[i] = course.quota;
        }

        return (courseCodes, names, statuses, quotas);
    }

    function getCourse(bytes32 _code)
        public
        view
        returns (
            string memory,
            uint,
            Status,
            bool
        )
    {
        Course memory course = courses[_code];

        require(course.exists, "Course does not exist");

        return (
            course.name,
            course.quota,
            course.status,
            course.exists
        );
    }
}
