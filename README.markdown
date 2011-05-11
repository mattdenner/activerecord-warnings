ActiveRecord Warnings
=====================
This gem adds support for warnings to ActiveRecord::Base instances.
Warnings do not fail the record being saved but should be presented to
the user.  The warnings work through the standard validation mechanism.

To add warnings to your model:

    class MyModel < ActiveRecord::Base
      warnings do
        validates_presence_of :name
      end
    end

    x = MyModel.create!
    x.warnings? # => true
    x.warnings.on(:name) # => "can't be blank"

Any validation calls within the `warnings` block will be classed as a
warning.  The `warnings` method returns an ActiveRecord::Errors
instance, just as the default `errors` implementation does.

