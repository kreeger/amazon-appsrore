# amazon_appstore

This Ruby gem provides a way to communicate with the Amazon Appstore App
Submission API for creating new versions, uploading APKs, and more.

Please note neither this codebase nor its creator are affiliated in any way with
Amazon, Inc. or its subsidiaries.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add amazon_appstore

If bundler is not being used to manage dependencies, install the gem by
executing:

    $ gem install amazon_appstore

## Usage

### Authentication

First off, make sure you understand how the App Submission API's
[authentication](https://developer.amazon.com/docs/app-submission-api/auth.html)
works. You will need a security profile with API access to the App Submission
API, along with the Client ID and Client Secret that go along with it. Once you
initialize this library with those 2 pieces of information, you'll be able to
ask it to authenticate, which will store the client credentials internally to be
used with subsequent requests.

```ruby
appstore = AmazonAppstore::Client.new(client_id: 'client-id',
                                      client_secret: 'client-secret')
appstore.authenticate_if_needed
# =^ returns <AmazonAppstore::ClientCredentials>
```

You can reused saved client credentials as well, if they are still valid.

```ruby
credentials = AmazonAppstore::ClientCredentials.new({
  'access_token' => 'abc123',
  'scope' => 'appstore::apps:readwrite',
  'token_type' => 'bearer',
  'expires_in' => 3600
})
appstore = AmazonAppstore::Client.new(client_id: 'client-id',
                                      client_secret: 'client-secret',
                                      client_credentials: credentials)
appstore.needs_authentication?
# =^ returns false
```

### Task flows

Next, you'll want to [familiarize yourself with the App Submission API's task
flows](https://developer.amazon.com/docs/app-submission-api/flows.html) to
understand the high level tasks you'll be performing when submitting apps to the
Amazon Appstore. In a nutshell:

* **All calls need to be authenticated** (aside from the authentication calls
  themselves)
* **To act upon existing API resources, you need to use the library to fetch
  them first**; this retains an ETag value for that resource, which the API
  requires for any write/delete operation for a resource
* **Appstore submission operates on _edits_** and you can only have one "open"
  at a time
* You will **create a new edit**, **modify its details** and how they differ
  from the previous version of the listing, **replace the previous version's
  APK(s)** or add new ones, optionally upload videos and images, **set time
  availability**, and finally **commit the edit** to submit it to the Appstore

Here is an incredibly basic example of how to accomplish this, with an existing
authenticated instance of `AmazonAppstore::Client` we're calling `appstore`.

```ruby
app_id = 'amzn1.devportal.mobileapp.abc'
edit = appstore.create_edit(app_id: app_id)
# =^ <AmazonAppstore::Edit id=>amzn1.devportal.apprelease.9fd9ded7f16e4b1ea89dc794b6e04328
#                      status=>IN_PROGRESS>

en_us_listing = appstore.get_listing('en-US', edit_id: edit.id, app_id: app_id)
# =^ <AmazonAppstore::Listing language=>en-US title=>My App>
en_us_listing.recent_changes = 'Some release notes go here.'
en_us_listing.full_description = 'In case I want to change my Appstore listing.'
appstore.update_listing(en_us_listing, edit_id: edit.id, app_id: app_id)
# =^ <AmazonAppstore::Listing language=>en-US title=>My App>

old_apk = appstore.get_apk('APK1', edit_id: edit.id, app_id: app_id)
# =^ <AmazonAppstore::APKMetadata id=>APK1 name=>my-app.apk version_code=12345678>
appstore.replace_apk('APK1',
                     apk_filepath: '../path/to/my-apk.apk',
                     edit_id: edit.id,
                     app_id: app_id)
# =^ <AmazonAppstore::APKMetadata id=>APK1 name=>my-app.apk version_code=23456789>

availability = appstore.get_availability(edit_id: edit.id, app_id: app_id)
# =^ <AmazonAppstore::Availability publishing_date=><AmazonAppstore::Availability::DatePair>>
date = AmazonAppstore::Availability::DatePair.new(date_time: '2022-02-27T15:19:37',
                                                  zone_id: 'US/Central')
availability.publishing_date = date
appstore.update_availability(availability)
# =^ <AmazonAppstore::Availability publishing_date=><AmazonAppstore::Availability::DatePair>>

# Validate; this will either return a 403 with a list of errors, or it will
#   return the same edit you sent
validated_edit = appstore.validate_edit(edit.id, app_id: app_id)
# =^ <AmazonAppstore::Edit id=>amzn1.devportal.apprelease.9fd9ded7f16e4b1ea89dc794b6e04328>
if validated_edit == edit
  submitted_edit = appstore.commit_edit(edit.id, app_id: app_id)
    # =^ <AmazonAppstore::Edit id=>amzn1.devportal.apprelease.9fd9ded7f16e4b1ea89dc794b6e04328>
end
```

For more information on what's possible, check out
`lib/amazon_appstore/client.rb` for fully-documented public methods.

## Development

This repo utilizes Visual Studio Code [Dev
Containers](https://code.visualstudio.com/docs/devcontainers/containers). Check
out the project, open it in VS Code and reopen it in a devcontainer, or spin up
a codespace. The correct version of Ruby will be loaded up and all necessary
Rubygems installed. A `launch.json` file is also supplied to help simplify
debugging files and unit tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/kreeger/amazon_appstore. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to adhere
to the [code of
conduct](https://github.com/kreeger/amazon_appstore/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the amazon_appstore project's codebases, issue trackers,
chat rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/kreeger/amazon_appstore/blob/main/CODE_OF_CONDUCT.md).
