class EntityItemMetadata {
    static registerInputKeyPress() {
        $('.metadata-input').keypress(function (event) {
            if(event.which == 13) {
                event.preventDefault();
                var $input = $(this);
                $input.parents('.form-group').siblings('.addMetaDataButton').find('button').click();
            }
        })
    }
    
    static registerFormSubmit() {
        $('.addEntityItemMetadataForm').submit(function () {
            //jquery object of the current form being submitted
            var $form = $(this);

            // this gets populated and later stringified, and assigned to a hidden input value in $form
            $form.metadata = {};
            $form.find('.inline-metadata-group').each(function () {
                EntityItemMetadata.groupProcessor($form, $(this));
            });

            var metadata = JSON.stringify($form.metadata);
            $form.find('.metadataDataHolder').val(metadata);
        })
    }

    static groupProcessor($form, $group) {
        var $field = $($group.find('input')[0]);
        var $value = $($group.find('input')[1]);

        if (EntityItemMetadata.validInput($field) && EntityItemMetadata.validInput($value)) {
            $form.metadata[$field.val().trim()] = $value.val().trim()
        }
    }

    static validInput($input) {
        return $input && $input.val() && $input.val().trim().length > 0
    }
}
