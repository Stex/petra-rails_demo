@title[Title]
<img src="https://drive.google.com/uc?id=1BKauBWbE66keL1gBBDfgSaRE0lL5x586&export=download" width="250" align="right" />
# petra
#### **pe**rsisted **tra**nsactions in ruby

---

* Shopping Cart
* Draft- / Preview Systems
* Batch editing

Changes are only visible to the current user until they are final => Sounds like transactions!

---

@title[Transactions]
### Transactions

* May only be processed completely or not at all
* Changes are not visible to the outside world until the transaction is committed

---

Classic Example:

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
* It should work with every Ruby object
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

---

Building a petra transaction

```ruby
user = User.petra.new('Foo', 'Bar')

Petra.transaction(identifier: 'tr1') do
  user.first_name = 'Moo'
  puts user.name #=> 'Moo Bar'
end

puts user.name #=> 'Foo Bar'
```

---

Adding a second section

```ruby
user = User.petra.new('Foo', 'Bar')

Petra.transaction(identifier: 'tr1') do
  user.first_name = 'Moo'
  puts user.name #=> 'Moo Bar'
end

puts user.name #=> 'Foo Bar'
```

```ruby
Petra.transaction(identifier: 'tr1') do
  user.last_name = 'Mar'
  puts user.name #=> 'Moo Mar'
end

puts user.name #=> 'Foo Bar'
```

---

Commit!

```ruby
user = User.petra.new('Foo', 'Bar')

Petra.transaction(identifier: 'tr1') do
  user.first_name = 'Moo'
  puts user.name #=> 'Moo Bar'
end

puts user.name #=> 'Foo Bar'
```

```ruby
Petra.transaction(identifier: 'tr1') do
  user.last_name = 'Mar'
  puts user.name #=> 'Moo Mar'
end

puts user.name #=> 'Foo Bar'
```

```ruby
Petra.transaction(identifier: 'tr1') do
  Petra.commit!
end

puts user.name #=> 'Moo Mar'
```

---

### Handling invalid transactions

#### A transaction becomes invalid

* on uncaught exceptions
* when the state of the outside world changed 
	* after we read an object
	* after we wrote an object

---

```ruby
user = User.petra.new('Foo', 'Bar')

Petra.transaction(identifier: 'tr1') do
  user.first_name = 'Moo'
end

user.first_name = 'Hoot'

Petra.transaction(identifier: 'tr1') do
  puts user.name
  user.last_name = 'Bam'
  puts user.name
end
```

---

```ruby
Petra.transaction(identifier: 'tr1') do
  puts user.name
  user.last_name = 'Bam'
  puts user.name
rescue Petra::WriteClashError => e
  if e.their_value.length < e.our_value.length
    e.use_ours!
    e.retry! # Try this section again
    e.reset! # OR: Reset the whole transaction
    e.continue! # OR: Continue the section execution from line 2
  end
end
```

---

![](https://media.giphy.com/media/McWbEQHVnFEiY/giphy.gif)

---

* petra uses a functionality called `Continuations`
* Power to restore a previous program stack
* petra sets a "savepoint" whenever an exception occurs

This may sound great, but keep it far away from all production code!

---

petra is just a proof of concept.

Wouldn't it be great if it could be more than that?

@fa[github gp-contact](`stex/petra`)

---

### Questions?