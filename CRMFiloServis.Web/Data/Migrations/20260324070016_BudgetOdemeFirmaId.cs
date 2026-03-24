using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CRMFiloServis.Web.Data.Migrations
{
    /// <inheritdoc />
    public partial class BudgetOdemeFirmaId : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "FirmaId",
                table: "BudgetOdemeler",
                type: "integer",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_BudgetOdemeler_FirmaId",
                table: "BudgetOdemeler",
                column: "FirmaId");

            migrationBuilder.AddForeignKey(
                name: "FK_BudgetOdemeler_Firmalar_FirmaId",
                table: "BudgetOdemeler",
                column: "FirmaId",
                principalTable: "Firmalar",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_BudgetOdemeler_Firmalar_FirmaId",
                table: "BudgetOdemeler");

            migrationBuilder.DropIndex(
                name: "IX_BudgetOdemeler_FirmaId",
                table: "BudgetOdemeler");

            migrationBuilder.DropColumn(
                name: "FirmaId",
                table: "BudgetOdemeler");
        }
    }
}
