//
//  {{file_name}}
//
// 
//  Auto generated from {{storyboard_name}} by StoryBoardConstantGenerator on {{generated_on}}
//  Any changes will be lost.
//

#import <Foundation/Foundation.h>
{% for controller in controllers %}{% for segue in controller.segues %}
extern NSString * const kPMSegueIdentifier{{ segue.identifier | capitaliseFirstChar }};
{% endfor %}{% endfor %}