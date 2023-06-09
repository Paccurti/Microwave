using Microsoft.EntityFrameworkCore;
using Microwave.Models;
using Microwave.Repositories.Interfaces;
using MicrowaveSystem.Data;

namespace Microwave.Repositories
{
    public class MicrowaveRepository : IMicrowaveRepository
    {
        private readonly MicrowaveSystemDBContext _dbContext;
        public MicrowaveRepository(MicrowaveSystemDBContext microwaveSystemDBContext)
        {
            _dbContext = microwaveSystemDBContext;
        }
        public async Task<List<MicrowaveModel>> GetAllMicrowaves()
        {
            return await _dbContext.Microwaves.ToListAsync();
        }

        public async Task<MicrowaveModel> GetMicrowaveById(int id)
        {
            return await _dbContext.Microwaves.FirstOrDefaultAsync(x => x.Id == id);
        }
        public async Task<MicrowaveModel> AddMicrowave(MicrowaveModel microwave)
        {
            await _dbContext.Microwaves.AddAsync(microwave);
            await _dbContext.SaveChangesAsync();

            return microwave;
        }
        public async Task<MicrowaveModel> UpdateMicrowave(MicrowaveModel microwave, int id)
        {
            MicrowaveModel microwaveById = await GetMicrowaveById(id);

            if (microwaveById == null)
            {
                throw new Exception($"Microondas para o ID: {id} não foi encontrado no banco de dados.");
            }

            microwaveById.CookingTime = microwave.CookingTime;
            microwaveById.Potency = microwave.Potency;
            microwaveById.IsRunning = microwave.IsRunning;

            _dbContext.Microwaves.Update(microwaveById);
            await _dbContext.SaveChangesAsync(); ;

            return microwaveById;
        }

        public async Task<MicrowaveModel> DeleteMicrowave(int id)
        {
            MicrowaveModel microwaveById = await GetMicrowaveById(id);

            if (microwaveById == null)
            {
                throw new Exception($"Microondas para o ID: {id} não foi encontrado no banco de dados.");
            }

            _dbContext.Microwaves.Remove(microwaveById);
            await _dbContext.SaveChangesAsync();

            return microwaveById;
        }


    }
}
