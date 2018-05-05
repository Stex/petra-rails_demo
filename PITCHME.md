@title[Title]
<img src="https://drive.google.com/uc?id=1BKauBWbE66keL1gBBDfgSaRE0lL5x586&export=download" width="250" align="right" />
# petra
#### **pe**rsisted **tra**nsactions in ruby

---

@title[Transactions]
### Transactions?

* May only be processed completely or not at all
* Changes are not visible to the outside world until the transaction is committed

---

### Classic Example:

```ruby
def withdraw(bank_account, amount)
  balance = bank_account.balance
  # Balance may have changed between 
  # the previous and the next line
  if balance >= amount
    bank_account.balance -= amount
  end
end    
```

=> We want everything to be executed atomically

---

@title[Transactions in ActiveRecord]

You're using transactions all the time:

```ruby
class User < ApplicationRecord
  after_save do
    # Changes are not visible to the world yet
  end
end
```

```ruby
class User < ApplicationRecord
  after_commit do
    # Changes **are** visible to the world
  end
end
```

---

Transactions are rolled back on exceptions

```ruby
class User < ApplicationRecord
  after_save do
    raise Exception
    #=> User is not saved, transaction is rolled back
  end
end
```

---


@title[Motivation]
## So why petra?

---

* ActiveRecord only uses database transactions
* Transactions can't be built over multiple requests

---

### Demo: User Management

---

### How did this work?

---

![](https://media.giphy.com/media/12NUbkX6p4xOO4/giphy.gif)

---

* petra wasn't meant to be used exclusively in Rails
* It should work on every Ruby object
* Usage without `petra-rails` is easier to understand

---

Simple `User` class

```ruby
class User
  attr_accessor :first_name
  attr_accessor :last_name

  def initialize(first_name, last_name)
    self.first_name, self.last_name = first_name, last_name
  end

  def name
    "#{first_name} #{last_name}"
  end
end
```  