//
//  {{file_name}}
//
// 
//  Auto generated from {{storyboard_name}} by StoryBoardConstantGenerator on {{generated_on}}
//  Any changes will be lost.
//

#import "{{ storyboard_name_short }}Segues.h"
{% for controller in controllers%}{% for segue in controller.segues %}
NSString * const kPMSegueIdentifier{{ segue.identifier | capitaliseFirstChar }} = @"{{ segue.identifier }}";
{% endfor %}{% endfor %}
