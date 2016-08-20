# MorseAssetable

## AR Helpers

<!--Add this line to model with assets:-->

<!--```ruby-->
<!--include MorseAssetable::ModelHelpers-->
<!--set_assetables(:asset, :large_image_one)-->
<!--```-->

<!--'set_assetables' allows you to specify the attributes which the model will belong to. e.g. ensure an attribute called 'large_image_one_id' exists on the model. Assetable will add the association. -->

<!--'Assetable automatically assumes a has_many relationship with the asset model. No configuration (i.e 'set_assetables') is required.-->

## View Helpers

Add this line to ApplicationHelper:

```ruby
include MorseAssetable::ViewHelpers
```

This gives you the following methods:

```ruby
asset_input(form_object, instance, base_name)
# base_name is the assoication to the asset eg ':asset' or ':large_image_one' 

multiple_assets(instance, form_object)

nice_asset(a, :version)
# if no version is selected it default to the original

```
