//-----------------------------------------------------------------------------
// Project     : VST SDK
// Version     : 3.6.5
//
// Category    : Helpers
// Filename    : public.sdk/source/vst/interappaudio/VST3Editor.mm
// Created by  : Steinberg, 08/2013.
// Description : VST 3 InterAppAudio
//
//-----------------------------------------------------------------------------
// LICENSE
// (c) 2015, Steinberg Media Technologies GmbH, All Rights Reserved
//-----------------------------------------------------------------------------
// This Software Development Kit may not be distributed in parts or its entirety
// without prior written agreement by Steinberg Media Technologies GmbH.
// This SDK must not be used to re-engineer or manipulate any technology used
// in any Steinberg or Third-party application or software module,
// unless permitted by law.
// Neither the name of the Steinberg Media Technologies nor the names of its
// contributors may be used to endorse or promote products derived from this
// software without specific prior written permission.
//
// THIS SDK IS PROVIDED BY STEINBERG MEDIA TECHNOLOGIES GMBH "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL STEINBERG MEDIA TECHNOLOGIES GMBH BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
// OF THE POSSIBILITY OF SUCH DAMAGE.
//-----------------------------------------------------------------------------

#import "VST3Editor.h"
#import "pluginterfaces/vst/ivsteditcontroller.h"

//------------------------------------------------------------------------
@interface VST3EditorViewController : UIViewController
//------------------------------------------------------------------------

@end

//------------------------------------------------------------------------
@implementation VST3EditorViewController
//------------------------------------------------------------------------

- (BOOL)prefersStatusBarHidden { return YES; }
- (BOOL)shouldAutorotate { return YES; }
- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
}

@end

namespace Steinberg {
namespace Vst {
namespace InterAppAudio {

//------------------------------------------------------------------------
VST3Editor::VST3Editor ()
: plugView (0)
, viewController (0)
{
	
}

//------------------------------------------------------------------------
VST3Editor::~VST3Editor ()
{
	if (plugView)
	{
		plugView->release ();
	}
}

//------------------------------------------------------------------------
bool VST3Editor::init (const CGRect& frame)
{
	viewController = [VST3EditorViewController new];
	viewController.view = [[UIView alloc] initWithFrame:frame];
	return true;
}

//------------------------------------------------------------------------
bool VST3Editor::attach (IEditController* editController)
{
	FUnknownPtr<IEditController2> ec2 (editController);
	if (ec2)
	{
		ec2->setKnobMode (kLinearMode);
	}
	plugView = editController->createView (ViewType::kEditor);
	if (plugView)
	{
		if (plugView->isPlatformTypeSupported (kPlatformTypeUIView) == kResultTrue)
		{
			plugView->setFrame (this);
			if (plugView->attached ((__bridge void*)viewController.view, kPlatformTypeUIView) == kResultTrue)
			{
				return true;
			}
		}
		plugView->release ();
		plugView = 0;
	}
	
	return false;
}

//------------------------------------------------------------------------
tresult PLUGIN_API VST3Editor::resizeView (IPlugView* view, ViewRect* newSize)
{
	return kNotImplemented;
}

}}}
