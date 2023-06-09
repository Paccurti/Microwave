using Microsoft.EntityFrameworkCore;
using Microwave.Data.Map;
using Microwave.Models;

namespace MicrowaveSystem.Data
{
    public class MicrowaveSystemDBContext : DbContext
    {
        public MicrowaveSystemDBContext(DbContextOptions<MicrowaveSystemDBContext> options)
            : base(options)
        {

        }

        public DbSet<UserModel> Users { get; set; }

        public DbSet<MicrowaveModel> Microwaves { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfiguration(new UserMap());
            modelBuilder.ApplyConfiguration(new MicrowaveMap());

            base.OnModelCreating(modelBuilder);
        }
    }
}
