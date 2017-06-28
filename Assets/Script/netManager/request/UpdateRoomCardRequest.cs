using System;
using System.Collections;

namespace AssemblyCSharp
{
	public class UpdateRoomCardRequest:ClientRequest
	{
		public UpdateRoomCardRequest(int count)
		{
			headCode = APIS.UPDATE_ROOMCARD_REQUEST;
			messageContent = count.ToString();
		}

	}
}

