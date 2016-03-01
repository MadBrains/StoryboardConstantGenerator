//
//  {{file_name}}
//
// 
//  Auto generated from {{storyboard_name}} by StoryBoardConstantGenerator on {{generated_on}}
//  Any changes will be lost.
//

#import "{{ storyboard_name_short }}TableViewCells.h"
{% for controller in controllers %}{% if controller.tableViewCells %}
#import "{{controller.class}}.h"

const struct {{ controller.class }}StoryboardCell {{ controller.class }}StoryboardCell = {
{
{% for tableViewCell in controller.tableViewCells %}	.kPMReuseIdentifier{{ tableViewCell.reuseIdentifier | capitaliseFirstChar }} = @"{{tableViewCell.reuseIdentifier}}";{% endfor %}
} {{ controller.class }}StoryboardCell;


@implementation {{ controller.class }} ( StoryboardCell )

@dynamic cell;

+(struct {{ controller.class }}StoryboardCell)cell {
   return {{ controller.class }}StoryboardCell;
}

-(struct {{ controller.class }}StoryboardCell)cell {
   return [self.class cell];
}

@end
{% endif %}{% endfor %}