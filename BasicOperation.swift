//
//  Created by Martin Prusa on 13/10/15.
//  Copyright © 2015 STRV. All rights reserved.
//

import Foundation

public class BasicOperation: NSOperation
{
    private var _finished : Bool = false
    private var _executing : Bool = false
    
    
    override public var asynchronous : Bool  {
        return true
    }
    
    
    override public var executing : Bool {
        
        get { return _executing }
        
        set {
            
            if newValue == true {
                willChangeValueForKey("isExecuting")
                NSThread.detachNewThreadSelector(Selector("main"), toTarget: self, withObject: nil)
                _executing = newValue
                didChangeValueForKey("isExecuting")
            } else {
                willChangeValueForKey("isExecuting")
                _executing = newValue
                didChangeValueForKey("isExecuting")
            }
        }
    }
    
    
    
    override public var finished : Bool {
        
        get { return _finished }
        
        set {
            willChangeValueForKey("isFinished")
            _finished = newValue
            didChangeValueForKey("isFinished")
        }
    }
    
    
    
    override public func start()
    {
        // Always check for cancellation before launching the task.
        if self.cancelled {
            self.finish()
            return
        }
        
        executing = true
    }
    
    
    
    public func finish()
    {
        executing = false
        finished = true
    }
    
    
    
    override public func main()
    {
        // do your implementation
        self.finish()
    }
}