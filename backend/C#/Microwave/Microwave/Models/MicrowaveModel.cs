namespace Microwave.Models
{
    public class MicrowaveModel
    {
        public int Id { get; set; }
        public bool IsRunning { get; set; }

        public int CookingTime { get; set; }

        public int Potency { get; set; }

        public MicrowaveModel()
        {
            //IsRunning = false;
            Potency = 10;
            CookingTime = 30;
        }
        public async Task Start(int? cookingTime, int? potency)
        {
            CookingTime = cookingTime ?? CookingTime;
            Potency = potency ?? Potency;

            // Iniciar contagem regressiva
            for (int i = CookingTime; i > 0; i--)
            {
                Console.WriteLine($"Tempo restante: {i} segundos");
                Thread.Sleep(1000); // Aguardar 1 segundo
            }

            // Encerrar a contagem
            //IsRunning = false;
            Console.WriteLine("Cozimento concluído.");
        }
        public async Task AddThirty(int? cookingTime, int? potency)
        {
            CookingTime = cookingTime ?? 30;
            Potency = potency ?? Potency;
            IsRunning = true;

            // Iniciar contagem regressiva
            for (int i = CookingTime; i > 0; i--)
            {
                Console.WriteLine($"Tempo restante: {i} segundos");
                Thread.Sleep(1000); // Aguardar 1 segundo
            }

            // Encerrar a contagem
            IsRunning = false;
            Console.WriteLine("Cozimento concluído.");
        }
    }


}
