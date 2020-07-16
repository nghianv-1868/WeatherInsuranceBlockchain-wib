<h1 align="center">Welcome to Wib 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-0.1.0-blue.svg?cacheSeconds=2592000" />
</p>

# Description

Wib is an idea based on a Weather Oracle of Chainlink. It allows users to purchase insurance at a place at any time (as long as 10 days after the current date). Perfect for event organizers who want to buy insurance for their events. All operations will be performed automatically via smart contract. From creating a contract, to checking insurance conditions and paying damages. No more thinking about cheating as human-operated systems.

# Main features:

- Create a new insurance contract
- See all user insurance packages purchased
- Check compensation conditions
- Receive payment for damages

# Some pictures

![image-01](https://user-images.githubusercontent.com/49506301/87528309-91768580-c6b7-11ea-9fa5-657216d77faa.png)

![image-03](https://user-images.githubusercontent.com/49506301/87528392-a94e0980-c6b7-11ea-811b-4e268b3736ce.png)

![image-04](https://user-images.githubusercontent.com/49506301/87528399-ab17cd00-c6b7-11ea-92f1-439ef3257a01.png)

![image-05](https://user-images.githubusercontent.com/49506301/87528403-ac48fa00-c6b7-11ea-8262-775e0cf3630e.png)

![image-02](https://user-images.githubusercontent.com/49506301/87528406-ae12bd80-c6b7-11ea-8050-550a2758a9aa.png)

# Video demo

<p align="center">
   <a target="_blank" href="https://www.youtube.com/watch?v=hxAdk3Smd-c">
    <img src="https://user-images.githubusercontent.com/49506301/87530521-a30d5c80-c6ba-11ea-9889-5da3c6d1ecc9.png" />
   </a>
</p>

<br/>

# Run product

#### Install dependencies

```sh
# install packages
cd contract
npm install

# compiler contract
truffle complier

# migrate contract - There will be 3 environments to migrate:
# - development
# - cldev
# - live (Here is deploy to the real environment - depending on the setup provider in the file `truffle-config.js`)

# Ex:
truffle migrate --network live
```

```sh
# run fronted
cd frontend
npm install
```

## Show your support

Give a ⭐️ if this project helped you!
