// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
class EntityType {
    static registerAddMetaDataClicks() {
        $('.addMetadataField').click(function(){
            //jquery object of the button that was clicked
            var $this = $(this);

            //gets all metadata containers and finds/stubs the placeholder one (hidden)
            var $metadataContainer = $this.parent().siblings('.metadata-container');
            var stub = $metadataContainer.find('.inline-metadata-group.placeholder')[0];

            //clone it, remove the placeholder class
            var $newMetadataGroup = $(stub).clone();
            $newMetadataGroup.removeClass('placeholder');

            // prepend to the metadata container!
            $metadataContainer.prepend($newMetadataGroup);
        });
    }

    static registerEvents() {
        EntityType.registerAddMetaDataClicks();
        EntityItemMetadata.registerFormSubmit();
        EntityItemMetadata.registerInputKeyPress();
    }
}

$(document).ready(function () {
    EntityType.registerEvents();
});
