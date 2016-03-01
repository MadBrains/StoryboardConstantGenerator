//
//  {{file_name}}
//
// 
//  Auto generated from {{storyboard_name}} by StoryBoardConstantGenerator on {{generated_on}}
//  Any changes will be lost.
//

#import <Foundation/Foundation.h>
{% for controller in controllers %}{% if controller.tableViewCells %}
#import "{{controller.class}}.h"

extern const struct {{ controller.class }}StoryboardCell 
{
{% for tableViewCell in controller.tableViewCells %}	__unsafe_unretained NSString*  kPMReuseIdentifier{{ tableViewCell.reuseIdentifier | capitaliseFirstChar }};{% endfor %}
} {{ controller.class }}StoryboardCell;


@interface {{ controller.class }} ( StoryboardCell )

@property (assign, nonatomic, readonly) struct {{ controller.class }}StoryboardCell cell;

+(struct {{ controller.class }}StoryboardCell)cell;

@end

{% endif %}{% endfor %}