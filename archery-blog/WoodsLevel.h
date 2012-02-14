//
//  HelloWorldLayer.h
//  archery-blog
//
//  Created by Matheus Teixeira Fernandes on 08/02/12.
//  Copyright UFSC 2012. All rights reserved.
//


#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

@interface WoodsLevel : CCLayer {
	b2World* world;
	GLESDebugDraw *m_debugDraw;
}

+(CCScene *) scene;

@end
