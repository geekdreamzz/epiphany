class AnalyzerForm {

    static registerFormSubmit() {
        $('.update-analyzer-form').submit(function () {
            //jquery object of the current form being submitted
            var $form = $(this);
            var tokenRules = AnalyzerForm.rulesHash($form.find('.analyzer-token-rules'));
            var displayValueRules = AnalyzerForm.rulesHash($form.find('.analyzer-display-val-rules'));
            var stringRules = JSON.stringify({
                forToken: tokenRules,
                forDisplayValue: displayValueRules
            });
            $form.find('.final-str-rules-placeholder').val(stringRules);
        })
    }

    static rulesHash($container) {
       var rules = {};
        $container.find('.rules-section').each(function () {
            var $section = $(this);
            var $key = $($section.find('select')[0]);
            var $val = $($section.find('select')[1]);
            if ($key && $val && $key.val().length > 1 && $val.val().length) {
                rules[$key.val()] = $val.val()
            }
        });
        return rules;
    };
}

$(document).ready(function () {
   AnalyzerForm.registerFormSubmit();
});
