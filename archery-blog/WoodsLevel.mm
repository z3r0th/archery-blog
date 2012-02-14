//
//  HelloWorldLayer.mm
//  archery-blog
//
//  Created by Matheus Teixeira Fernandes on 08/02/12.
//  Copyright UFSC 2012. All rights reserved.
//


#import "WoodsLevel.h"

#define PTM_RATIO 32

@interface WoodsLevel ()

- (void)initBox2DDebugger;
- (void)initBox2DWorld;

@end

@implementation WoodsLevel


#pragma mark - Static Methods

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	
	WoodsLevel *layer = [WoodsLevel node];
	[scene addChild: layer];
	
	return scene;
}


#pragma mark - Initialization Methods

-(id) init {
    self = [super init];
	if(self) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		
		[self schedule: @selector(update:)];
	}
    
	return self;
}

- (void)initBox2DDebugger {
    b2Vec2 gravity;
    gravity.Set(0.0f, -10.0f);
    bool doSleep = true;
    world = new b2World(gravity, doSleep);
    world->SetContinuousPhysics(true);
}

- (void)initBox2DWorld {
    m_debugDraw = new GLESDebugDraw( PTM_RATIO );
    world->SetDebugDraw(m_debugDraw);
    
    uint32 flags = 0;
    flags += b2DebugDraw::e_shapeBit;
    //		flags += b2DebugDraw::e_jointBit;
    //		flags += b2DebugDraw::e_aabbBit;
    //		flags += b2DebugDraw::e_pairBit;
    //		flags += b2DebugDraw::e_centerOfMassBit;
    m_debugDraw->SetFlags(flags);	
}

- (void)initLimits {
    CGSize screenSize = [CCDirector sharedDirector].winSize;	
    
    
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0);
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    
    b2PolygonShape groundBox;		
    
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
    
    groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
    groundBody->CreateFixture(&groundBox,0);
    
    groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
    groundBody->CreateFixture(&groundBox,0);
    
    groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
}


#pragma mark - Draw Methods

-(void)draw {
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}


#pragma mark - Update Methods

- (void)update:(ccTime)deltaTime {	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;

	world->Step(deltaTime, velocityIterations, positionIterations);

	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
}


#pragma mark - User Input Methods

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
	}
}


#pragma mark - Memory Management

- (void) dealloc {
	delete world;
	world = NULL;
	
	delete m_debugDraw;

	[super dealloc];
}
@end
