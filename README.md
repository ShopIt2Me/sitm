Shop.me is a web application aimed to provide you with curated products based on your likes and dislikes. With a sleek, dynamic and simple UI you can browse for your next favorite look. Built upon Amazon's product advertising API, you can checkout directly with Amazon. 

Shop.me's production app can be found at [shop-me.herokuapp.com](http://shop-me.herokuapp.com).

Developer Setup:
* Bundle gems: `$bundle`

* Initialize the database: `$rake db:create`, `$rake db:migrate`

* Create .env file to store API information
  `$touch .env.development`
```
AWS_ACCESS_KEY_ID=Amazon-API-key
AWS_SECRET_ACCESS_KEY=Amazon-API-secret
ASSOCIATE_TAG=Amazon-associate-tag
```

* Seed database: `$rake db:seed`

