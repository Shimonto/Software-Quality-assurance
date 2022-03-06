mtype={quantity_lessthan_stocksize, quantity_greaterthan_stocksize, valid_request, invalid_request, save_validrequest, save_invalidrequest, request_saved, request_rejected, success, error};
chan to_user = [3] of {mtype};
chan to_webapp = [5] of {mtype};
chan to_server = [2] of {mtype};

active proctype user()
{
	start:
	if 
	:: to_webapp!quantity_lessthan_stocksize -> goto L1
	:: to_webapp!quantity_greaterthan_stocksize -> goto L2
	fi

L1:	
	to_webapp!valid_request;	
	to_webapp?success;
       goto start
L2:	
	to_webapp!invalid_request;	
	to_webapp?error;
        goto start
}

active proctype webapp()
{
	start:
	if 
	:: to_webapp?quantity_lessthan_stocksize -> goto L1
	:: to_webapp?quantity_greaterthan_stocksize -> goto L2
	fi

L1:	
	to_webapp?valid_request;	
	to_server!save_validrequest;
        	to_server?request_saved;	
	to_webapp!success;
       goto start

L2:	
	to_webapp?invalid_request;	
	to_server!save_invalidrequest;
        	to_server?request_rejected;	
	to_webapp!error;
        goto start
}

active proctype server()
{
	start:
	if
	::to_server?save_validrequest -> goto L1
	::to_server?save_invalidrequest -> goto L2
	fi

L1:	
        to_server!request_saved;	
        goto start
L2:	
        to_server!request_rejected;	
        goto start
}
