using System;
using NATS.Client;

namespace dotnet.Services
{
    public interface IQueueService
    {
        bool Publish(string subject, string message);
    }

    public class QueueService : IQueueService
    {
        IConnection nats;
        IConnection Nats
        {
            get
            {
                try
                {
                    if (nats == null)
                    {
                        ConnectionFactory factory = new ConnectionFactory();
                        Options options = ConnectionFactory.GetDefaultOptions();
                        options.Url = string.IsNullOrEmpty(Environment.GetEnvironmentVariable("NATS_URI")) ?
                                        "nats://localhost:4222" :
                                        Environment.GetEnvironmentVariable("NATS_URI");
                        options.MaxReconnect = NATS.Client.Options.ReconnectForever;
                        options.ReconnectWait = 250;
                        options.AllowReconnect = true;
                        options.Timeout = 5000;
                        nats = factory.CreateConnection(options);
                    }
                    return nats;
                }
                catch
                {
                    return null;
                }
            }
        }

        public bool Publish(string subject, string message)
        {
            if (Nats != null)
            {
                Nats.Publish(subject, System.Text.Encoding.ASCII.GetBytes(message));
                return true;
            }
            return false;
        }
    }
}