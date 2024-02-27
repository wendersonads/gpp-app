import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { PecaModel } from 'src/app/models/PecaModel';
import { ProdutoModel } from 'src/app/models/ProdutoModel';
import { SolicitacaoAstecaModel } from 'src/app/models/SolicitacaoAstecaModel';
import { PecaService } from 'src/app/services/peca.service';
import { ProdutoService } from 'src/app/services/produto.service';

@Component({
  selector: 'app-asteca-edit',
  templateUrl: './asteca-edit.component.html',
  styleUrls: ['./asteca-edit.component.css']
})
export class AstecaEditComponent implements OnInit {

  displayDialog: boolean = true;
  peca: PecaModel = new PecaModel();
  asteca: SolicitacaoAstecaModel = new SolicitacaoAstecaModel();
  fornecedores: string[] = []; // Populate this array with the list of fornecedores
  produtos: ProdutoModel[] = [];
  pageTitle: string = 'Edição';
  astecaForm!: FormGroup; // Add "!" to indicate that it will be initialized in the constructor
  selectedProduto: ProdutoModel | null = null;

  constructor(
    private pecaService: PecaService,
    private router: Router,
    private route: ActivatedRoute,
    private produtoService: ProdutoService,
    private formBuilder: FormBuilder
  ) {
    this.buildForm(); // Call the buildForm method to initialize the pecaForm
  }

  ngOnInit(): void {
  }

  // asteca : SolicitacaoAstecaModel{

  // }

  private buildForm(): void {
    this.astecaForm = this.formBuilder.group({
      numero: ['', [Validators.required, Validators.pattern('^[0-9]+$')]],
    });
  }

  cancelar(): void {
    this.router.navigateByUrl('/astecaList');
  }

  onDialogHide(): void {
    this.cancelar();
  }

  public editar(): void {
    if (this.astecaForm.invalid) {
      return;
    }

    this.asteca = { ...this.asteca, ...this.astecaForm.value };
    // this.peca.idFornecedor = this.selectedProduto?.fornecedor?.idFornecedor;

    this.pecaService.add(this.peca).subscribe(() => {
      this.peca = new PecaModel();
      this.router.navigateByUrl('/astecaList');
    });
  }

}
