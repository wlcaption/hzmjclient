using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MyDebuger {

    static public bool EnableLog = true;
    static public void Log(object message)
    {
        Log(message, null);
    }

    static public void Log(object message, Object context)
    {
        if (EnableLog)
        {
            Debug.Log(message, context);
        }
    }

    static public void LogError(object message)
    {
        LogError(message, null);
    }

    static public void LogError(object message, Object context)
    {
        if (EnableLog)
        {
            Debug.LogError(message, context);
        }
    }

    static public void LogWarning(Object message)
    {
        LogWarning(message, null);
    }

    static public void LogWarning(Object message, Object context)
    {
        if (EnableLog)
        {
            Debug.LogWarning(message, context);
        }
    }
}
