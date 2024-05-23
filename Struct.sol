// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Struct {
    struct Person {
        string name;
        uint256 age;
    }
    Person public aa = Person("aa", 8);

    Person public bb = Person({name: "bb", age: 9});

    // 方括号里可以指定数组的长度 Person[3] public xxx; 也可以不指定
    Person[] public useList;

    function push(string memory _name, uint256 _age) public {
        useList.push(Person(_name, _age));
    }

    // function get() public pure returns(Person) {
    //    aa;
    // }
}

// struct 也可以写在 contract 外部
struct A {
    uint n;
}
