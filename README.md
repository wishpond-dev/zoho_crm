# ZohoCrm

zoho_crm is a basic gem to interact with the Zoho API. Methods are only available for the Leads and Contacts Zoho modules. Communication is through instantiation of the main class **ZohoCRM::Client** which requires the user to have a Zoho username and password.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zoho_crm'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zoho_crm

## Usage

Instantiate a client:

```ruby
client = ZohoCrm::Client.new("zoho@email.com", "myzohopassword")
```

Generate a token:

```ruby
auth_token = client.authenticate_user
```

Now that we have a client and an authentication token, we can interact with the Zoho API.

The methods for the Contacts module are as follows:

```ruby
client.retrieve_contacts(auth_token)
```

Which returns a response in JSON format.

**data** is required to be supplied in the following format:

```ruby
data = {
          first_name: "Roger",
          last_name: "Jones",
          email: "roger@jones.com"
        }
```
**id** is the Zoho Contact ID which is can be found as part of the JSON response when using the **retrieve_contacts** method.

```ruby
client.new_contact(auth_token, data)
```

```ruby
client.update_contact(auth_token, data, id)
```

Where only the fields to be updated need be supplied in **data**. The other fields will remain untouched.

```ruby
client.delete_contact(auth_token, id)
```

Zoho requires **last_name** for Contacts. zoho_crm supported field names for the Contacts module are:

```ruby
data = {
          first_name: "Roger",
          last_name: "Jones",
          title: "CFO",
          department: "Leveraged Loans",
          phone: "1234",
          mobile: "1234",
          home_phone: "1234",
          other_phone: "1234",
          email: "roger@jones.com",
          mailing_street: "Welland Mews",
          mailing_city: "Welland Town",
          mailing_state: "Wellandville"
          mailing_zip: "ABC123"
          mailing_country: "Welland Republic"
          description: "a description"
        }
```

Limitations of these fields can be found at https://www.zoho.com/crm/help/api/modules-fields.html#Contacts

The methods for the Leads module are as follows:

```ruby
client.retrieve_leads(auth_token)
```

Which returns a response in JSON format.

**data** is required to be supplied in the following format:

```ruby
data = {
          first_name: "Roger",
          last_name: "Jones",
          email: "roger@jones.com"
        }
```
**id** is the Zoho Lead ID which is can be found as part of the JSON response when using the **retrieve_leads** method.

```ruby
client.new_lead(auth_token, data)
```

```ruby
client.update_lead(auth_token, data, id)
```

Where only the fields to be updated need be supplied in **data**. The other fields will remain untouched.

```ruby
client.delete_lead(auth_token, id)
```

Zoho requires **last_name** and **company** for Leads. The zoho_crm supported field names for the Leads module are:

```ruby
data = {
          first_name: "Roger",
          last_name: "Jones",
          title: "CFO",
          company: "Welland Capital",
          phone: "1234",
          mobile: "1234",
          email: "roger@jones.com",
          street: "Welland Mews",
          city: "Welland Town",
          state: "Wellandville"
          zip: "ABC123"
          country: "Welland Republic"
          description: "a description"
        }
```

Limitations of these fields can be found at https://www.zoho.com/crm/help/api/modules-fields.html#Leads

The fields for both the Contacts and Leads modules can be obtained with the following method:

```ruby
client.get_fields(auth_token, module_name)
```

Which returns a response in JSON format.

Where **module_name** is either:

```ruby
"Contacts"
```

or

```ruby
"Leads"
```

If custom fields have been added to either the Contacts or Leads modules by a Zoho user then this will be indicated in the response from the **get_fields** method.

Provided a Zoho user has added custom fields, these can be populated using the **new_contact** , **new_lead** , **update_contact** and **update_lead** methods.

These can be added to **data** with the custom field name as a key in the hash in lower snake case. For example, if a Zoho user add custom fields **Gender** and **Football Team** then **data** would be:

```ruby
data = {
          gender: "Undisclosed",
          football_team: "Welland FC"
        }
```

The zoho_crm currently does not support batch updates. Contacts and Leads must be created or updated individually.

N.B. It appears that zoho will only let 9 concurrent auth tokens be generated for each account. These auth tokens can be deleted manually in the 'My Account' section on Zoho.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/zoho_crm/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
