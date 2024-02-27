import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { PecaModel } from 'src/app/models/PecaModel';
import { ProdutoModel } from 'src/app/models/ProdutoModel';
import { PecaService } from '../../services/peca.service';
import { ProdutoService } from 'src/app/services/produto.service';

@Component({
  selector: 'app-peca-edit',
  templateUrl: './peca-edit.component.html',
  styleUrls: ['./peca-edit.component.css']
})
export class PecaEditComponent implements OnInit {
  displayDialog: boolean = true;
  peca: PecaModel = new PecaModel();
  fornecedores: string[] = []; // Populate this array with the list of fornecedores
  produtos: ProdutoModel[] = [];
  pageTitle: string = 'Edição';
  pecaForm!: FormGroup; // Add "!" to indicate that it will be initialized in the constructor
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
    const id = Number(this.route.snapshot.paramMap.get('id'));
    this.pecaService.getPorIdPeca(id).subscribe(peca => {
      this.peca = peca;
      this.peca.produto = { ...peca.produto };
      this.pecaForm.patchValue(this.peca);
    });

    this.produtoService.list().subscribe(produtos => {
      this.produtos = produtos;
    });
  }

  public editar(): void {
    if (this.pecaForm.invalid) {
      return;
    }

    this.peca = { ...this.peca, ...this.pecaForm.value };
    // this.peca.idFornecedor = this.selectedProduto?.fornecedor?.idFornecedor;

    this.pecaService.add(this.peca).subscribe(() => {
      this.peca = new PecaModel();
      this.router.navigateByUrl('/pecaList');
    });
  }

  cancelar(): void {
    this.router.navigateByUrl('/pecaList');
  }

  onDialogHide(): void {
    this.cancelar();
  }
  getSelectedProdutoFornecedorNome(): string {
    const selectedProduto = this.pecaForm.get('produto')?.value;
    return selectedProduto?.fornecedor?.nomeFornecedor || '';
  }
  
  private buildForm(): void {
    this.pecaForm = this.formBuilder.group({
      numero: ['', [Validators.required, Validators.pattern('^[0-9]+$')]],
      codigoFabrica: ['', Validators.required],
      unidade: ['', [Validators.required, Validators.pattern('^[0-9]+$')]],
      descricao: ['', Validators.required],
      altura: ['', [Validators.required, Validators.pattern('^[0-9]+(\\.[0-9]{1,2})?$')]],
      largura: ['', [Validators.required, Validators.pattern('^[0-9]+(\\.[0-9]{1,2})?$')]],
      profundidade: ['', [Validators.required, Validators.pattern('^[0-9]+(\\.[0-9]{1,2})?$')]],
      unidadeMedida: ['', Validators.required],
      volumes: ['', [Validators.required, Validators.pattern('^[0-9]+(\\.[0-9]{1,2})?$')]],
      active: [false],
      custo: ['', [Validators.required, Validators.pattern('^[0-9]+(\\.[0-9]{1,2})?$')]],
      cor: ['', Validators.required],
      material: ['', Validators.required],
      produto: ['', Validators.required]
    });
  }
}
