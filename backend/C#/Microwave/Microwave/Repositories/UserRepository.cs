using Microwave.Models;
using MicrowaveSystem.Data;
using Microwave.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace Microwave.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly MicrowaveSystemDBContext _dbContext;
        public UserRepository(MicrowaveSystemDBContext microwaveSystemDBContext)
        {
            _dbContext = microwaveSystemDBContext;
        }
        public async Task<List<UserModel>> GetAllUsers()
        {
            return await _dbContext.Users.ToListAsync();
        }
        public async Task<UserModel> GetUserById(int id)
        {
            return await _dbContext.Users.FirstOrDefaultAsync(x => x.Id == id);
        }
        public async Task<UserModel> AddUser(UserModel user)
        {
            await _dbContext.Users.AddAsync(user);
            await _dbContext.SaveChangesAsync();

            return user;
        }
        public async Task<UserModel> UpdateUser(UserModel user, int id)
        {
            UserModel userById = await GetUserById(id);

            if(userById == null)
            {
                throw new Exception($"Usuário para o ID: {id} não foi encontrado no banco de dados.");
            }

            userById.Name = user.Name;
            userById.Email = user.Email;

            _dbContext.Users.Update(userById);
            await _dbContext.SaveChangesAsync(); ;

            return userById;
        }
        public async Task<UserModel> DeleteUser(int id)
        {
            UserModel userById = await GetUserById(id);

            if (userById == null)
            {
                throw new Exception($"Usuário para o ID: {id} não foi encontrado no banco de dados.");
            }

            _dbContext.Users.Remove(userById);
            await _dbContext.SaveChangesAsync();

            return userById;
        }
    }
}
